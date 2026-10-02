import { useState } from 'react'
import type { FormEvent } from 'react'
import {
  AlertTriangle,
  ArrowUpRight,
  Boxes,
  Building2,
  CheckCircle2,
  ChevronRight,
  CircleDollarSign,
  Clock3,
  Database,
  Factory,
  FileSearch,
  LayoutDashboard,
  Menu,
  MessageSquareText,
  PackageCheck,
  Send,
  ShieldCheck,
  Sparkles,
  Truck,
  X,
} from 'lucide-react'
import {
  Alert,
  Button,
  Chip,
  CircularProgress,
  TextField,
  ToggleButton,
  ToggleButtonGroup,
} from '@mui/material'
import { useMutation, useQuery } from '@tanstack/react-query'
import {
  Area,
  AreaChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip as ChartTooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { api, ApiError } from './api'
import {
  demoChatResponse,
  fallbackPartRisks,
  fallbackSummary,
  fallbackSuppliers,
  monthlyDelivery,
} from './demoData'
import type {
  ChatResponse,
  DashboardSummary,
  PartRisk,
  Persona,
  SupplierPerformance,
} from './types'

const navItems = [
  { label: 'Overview', icon: LayoutDashboard, target: 'overview' },
  { label: 'Suppliers', icon: Building2, target: 'suppliers' },
  { label: 'Inventory', icon: Boxes, target: 'inventory' },
  { label: 'Ask SupplyGraph', icon: MessageSquareText, target: 'assistant' },
]

const promptSuggestions = [
  'What is on-time delivery this month?',
  'What is our overall fill rate?',
  'How much is total landed cost?',
  'How many customer orders are affected?',
]

function formatNumber(value: number) {
  return new Intl.NumberFormat('en-US').format(value)
}

function formatCurrency(value: number, currency = 'USD') {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
    notation: 'compact',
    maximumFractionDigits: 1,
  }).format(value)
}

function scrollTo(target: string) {
  document.getElementById(target)?.scrollIntoView({ behavior: 'smooth' })
}

function MetricCard({
  label,
  value,
  context,
  icon: Icon,
  tone,
}: {
  label: string
  value: string
  context: string
  icon: typeof Truck
  tone: 'teal' | 'amber' | 'coral' | 'blue'
}) {
  return (
    <article className={`metric-card metric-card--${tone}`}>
      <div className="metric-card__topline">
        <span>{label}</span>
        <Icon size={18} strokeWidth={1.8} aria-hidden="true" />
      </div>
      <strong>{value}</strong>
      <small>{context}</small>
    </article>
  )
}

function StatusPill({ status }: { status: string }) {
  const className = status === 'HEALTHY' || status === 'ACTIVE' ? 'healthy' : 'risk'
  return (
    <span className={`status-pill status-pill--${className}`}>
      {status.replace('_', ' ')}
    </span>
  )
}

export default function SupplyGraphApp() {
  const [mobileNavOpen, setMobileNavOpen] = useState(false)
  const [persona, setPersona] = useState<Persona>('planning')
  const [question, setQuestion] = useState(promptSuggestions[0])

  const summaryQuery = useQuery<DashboardSummary>({
    queryKey: ['dashboard-summary'],
    queryFn: () => api.get('/dashboard/summary'),
    retry: 1,
  })
  const suppliersQuery = useQuery<SupplierPerformance[]>({
    queryKey: ['suppliers'],
    queryFn: () => api.get('/suppliers?limit=5'),
    retry: 1,
  })
  const risksQuery = useQuery<PartRisk[]>({
    queryKey: ['part-risks'],
    queryFn: () => api.get('/parts/risk?limit=6'),
    retry: 1,
  })
  const chatMutation = useMutation<ChatResponse, Error>({
    mutationFn: () => api.post('/chat', { question, persona }),
  })

  const summary = summaryQuery.data ?? fallbackSummary
  const suppliers = suppliersQuery.data ?? fallbackSuppliers
  const risks = risksQuery.data ?? fallbackPartRisks
  const usingSnapshot = [summaryQuery, suppliersQuery, risksQuery].some(
    (query) => query.isError,
  )
  const isConnecting = [summaryQuery, suppliersQuery, risksQuery].some(
    (query) => query.isPending,
  )
  const unsupportedMessage =
    chatMutation.error instanceof ApiError && chatMutation.error.status === 422
      ? chatMutation.error.message
      : null
  const assistantResult =
    chatMutation.data ??
    (chatMutation.isError && !unsupportedMessage
      ? demoChatResponse(question, persona)
      : null)

  const handleAsk = (event: FormEvent) => {
    event.preventDefault()
    if (question.trim().length >= 3) {
      chatMutation.mutate()
    }
  }

  const handleNav = (target: string) => {
    scrollTo(target)
    setMobileNavOpen(false)
  }

  return (
    <div className="app-shell">
      <button
        className="mobile-menu-button"
        type="button"
        aria-label="Open navigation"
        onClick={() => setMobileNavOpen(true)}
      >
        <Menu size={22} />
      </button>

      <aside className={`sidebar ${mobileNavOpen ? 'sidebar--open' : ''}`}>
        <div className="brand-lockup">
          <div className="brand-mark" aria-hidden="true">
            <span />
            <span />
            <span />
          </div>
          <div>
            <strong>SupplyGraph</strong>
            <small>AI control tower</small>
          </div>
          <button
            className="sidebar-close"
            type="button"
            aria-label="Close navigation"
            onClick={() => setMobileNavOpen(false)}
          >
            <X size={20} />
          </button>
        </div>

        <nav aria-label="Primary navigation">
          <p className="nav-label">Workspace</p>
          {navItems.map(({ label, icon: Icon, target }, index) => (
            <button
              key={label}
              className={index === 0 ? 'nav-item nav-item--active' : 'nav-item'}
              type="button"
              onClick={() => handleNav(target)}
            >
              <Icon size={18} strokeWidth={1.8} />
              <span>{label}</span>
              {index === 3 && <Sparkles size={14} className="nav-spark" />}
            </button>
          ))}
        </nav>

        <div className="governance-note">
          <ShieldCheck size={20} aria-hidden="true" />
          <div>
            <strong>Governed by design</strong>
            <span>9 canonical metrics</span>
          </div>
        </div>

        <div className="sidebar-footer">
          <Database size={17} aria-hidden="true" />
          <div>
            <span>Snowflake</span>
            <small>SUPPLYGRAPH</small>
          </div>
          <span className="connection-dot" />
        </div>
      </aside>

      {mobileNavOpen && (
        <button
          className="sidebar-scrim"
          type="button"
          aria-label="Close navigation"
          onClick={() => setMobileNavOpen(false)}
        />
      )}

      <main className="main-content">
        <header className="topbar">
          <div>
            <span className="breadcrumb">Operations / Control tower</span>
            <h1>Supply chain overview</h1>
          </div>
          <div className="topbar-actions">
            <Chip
              size="small"
              icon={
                usingSnapshot ? (
                  <FileSearch size={15} />
                ) : (
                  <CheckCircle2 size={15} />
                )
              }
              label={
                isConnecting
                  ? 'Connecting'
                  : usingSnapshot
                    ? 'Demo snapshot'
                    : 'Live governed data'
              }
              className={
                usingSnapshot ? 'source-chip source-chip--demo' : 'source-chip'
              }
            />
            <div className="as-of">
              <span>Data through</span>
              <strong>30 Sep 2026</strong>
            </div>
          </div>
        </header>

        <div className="content-wrap">
          {usingSnapshot && (
            <Alert severity="info" className="snapshot-alert">
              FastAPI is unavailable, so the interface is showing the validated
              Snowflake demo snapshot.
            </Alert>
          )}

          <section id="overview" className="section-block">
            <div className="section-heading">
              <div>
                <span className="eyebrow">Network pulse</span>
                <h2>What needs attention</h2>
              </div>
              <button
                className="text-action"
                type="button"
                onClick={() => scrollTo('assistant')}
              >
                Ask about these metrics <ArrowUpRight size={16} />
              </button>
            </div>

            <div className="metric-grid">
              <MetricCard
                label="On-time delivery"
                value={`${summary.on_time_delivery_rate.toFixed(1)}%`}
                context="Across completed shipments"
                icon={Truck}
                tone="teal"
              />
              <MetricCard
                label="Fill rate"
                value={`${summary.fill_rate.toFixed(1)}%`}
                context={`${formatNumber(summary.order_count)} customer orders`}
                icon={PackageCheck}
                tone="blue"
              />
              <MetricCard
                label="At-risk parts"
                value={formatNumber(summary.at_risk_part_count)}
                context="Below governed thresholds"
                icon={AlertTriangle}
                tone="coral"
              />
              <MetricCard
                label="Landed cost"
                value={formatCurrency(
                  summary.total_landed_cost,
                  summary.currency,
                )}
                context="Material + logistics costs"
                icon={CircleDollarSign}
                tone="amber"
              />
            </div>

            <div className="overview-grid">
              <article className="panel trend-panel">
                <div className="panel-heading">
                  <div>
                    <span className="panel-kicker">Delivery reliability</span>
                    <h3>On-time delivery trend</h3>
                  </div>
                  <span className="decline-badge">22.3 pts since March</span>
                </div>
                <div
                  className="chart-wrap"
                  aria-label="Monthly on-time delivery chart"
                >
                  <ResponsiveContainer width="100%" height="100%">
                    <AreaChart
                      data={monthlyDelivery}
                      margin={{ top: 12, right: 12, left: -22, bottom: 0 }}
                    >
                      <defs>
                        <linearGradient
                          id="deliveryFill"
                          x1="0"
                          y1="0"
                          x2="0"
                          y2="1"
                        >
                          <stop
                            offset="0%"
                            stopColor="#1e756d"
                            stopOpacity={0.24}
                          />
                          <stop
                            offset="100%"
                            stopColor="#1e756d"
                            stopOpacity={0}
                          />
                        </linearGradient>
                      </defs>
                      <CartesianGrid
                        stroke="#e6e9e7"
                        strokeDasharray="3 5"
                        vertical={false}
                      />
                      <XAxis
                        dataKey="month"
                        axisLine={false}
                        tickLine={false}
                        tick={{ fill: '#68736f', fontSize: 12 }}
                      />
                      <YAxis
                        domain={[40, 100]}
                        axisLine={false}
                        tickLine={false}
                        tick={{ fill: '#68736f', fontSize: 12 }}
                        tickFormatter={(value) => `${value}%`}
                      />
                      <ChartTooltip
                        contentStyle={{
                          border: '1px solid #dce1de',
                          borderRadius: 6,
                          boxShadow: '0 8px 24px rgba(25, 41, 36, 0.08)',
                        }}
                        formatter={(value) => [
                          `${Number(value).toFixed(2)}%`,
                          'On-time delivery',
                        ]}
                      />
                      <Area
                        type="monotone"
                        dataKey="rate"
                        stroke="#1e756d"
                        strokeWidth={2.5}
                        fill="url(#deliveryFill)"
                        activeDot={{
                          r: 5,
                          fill: '#1e756d',
                          stroke: '#ffffff',
                          strokeWidth: 2,
                        }}
                      />
                    </AreaChart>
                  </ResponsiveContainer>
                </div>
              </article>

              <article className="panel signal-panel">
                <div className="panel-heading">
                  <div>
                    <span className="panel-kicker">Priority signals</span>
                    <h3>Current exposure</h3>
                  </div>
                </div>
                <div className="signal-list">
                  <button type="button" onClick={() => scrollTo('suppliers')}>
                    <span className="signal-icon signal-icon--coral">
                      <Factory size={18} />
                    </span>
                    <span>
                      <strong>
                        {suppliers[0]?.supplier_name ?? 'Supplier watchlist'}
                      </strong>
                      <small>Highest average delivery delay</small>
                    </span>
                    <ChevronRight size={17} />
                  </button>
                  <button type="button" onClick={() => scrollTo('inventory')}>
                    <span className="signal-icon signal-icon--amber">
                      <Boxes size={18} />
                    </span>
                    <span>
                      <strong>
                        {summary.at_risk_part_count} part-location risks
                      </strong>
                      <small>Stockout and low-cover exposure</small>
                    </span>
                    <ChevronRight size={17} />
                  </button>
                  <button type="button" onClick={() => scrollTo('assistant')}>
                    <span className="signal-icon signal-icon--blue">
                      <Clock3 size={18} />
                    </span>
                    <span>
                      <strong>
                        {summary.affected_order_count} affected orders
                      </strong>
                      <small>Linked to delayed inbound supply</small>
                    </span>
                    <ChevronRight size={17} />
                  </button>
                </div>
              </article>
            </div>
          </section>

          <section id="suppliers" className="section-block">
            <div className="section-heading compact">
              <div>
                <span className="eyebrow">Supplier performance</span>
                <h2>Delay watchlist</h2>
              </div>
              <span className="section-note">Ranked by average late days</span>
            </div>
            <div className="data-table-wrap">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>Supplier</th>
                    <th>Region</th>
                    <th>On-time</th>
                    <th>Avg. delay</th>
                    <th>Defect rate</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {suppliers.map((supplier) => (
                    <tr key={supplier.supplier_id}>
                      <td>
                        <strong>{supplier.supplier_name}</strong>
                        <small>{supplier.supplier_id}</small>
                      </td>
                      <td>{supplier.region}</td>
                      <td>{supplier.on_time_delivery_rate.toFixed(1)}%</td>
                      <td>
                        {supplier.average_delivery_delay_days.toFixed(1)} days
                      </td>
                      <td>{supplier.defect_rate.toFixed(1)}%</td>
                      <td>
                        <StatusPill status={supplier.supplier_status} />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>

          <section id="inventory" className="section-block">
            <div className="section-heading compact">
              <div>
                <span className="eyebrow">Inventory coverage</span>
                <h2>Part-location risk</h2>
              </div>
              <span className="section-note">
                Latest governed inventory snapshot
              </span>
            </div>
            <div className="risk-grid">
              {risks.slice(0, 6).map((risk) => (
                <article
                  className="risk-row"
                  key={`${risk.plant_id}-${risk.part_id}`}
                >
                  <div className="risk-score">{risk.risk_score}</div>
                  <div className="risk-main">
                    <strong>{risk.part_name}</strong>
                    <span>
                      {risk.plant_name} · {risk.criticality}
                    </span>
                  </div>
                  <div className="risk-quantity">
                    <strong>{formatNumber(risk.net_available_quantity)}</strong>
                    <span>net available</span>
                  </div>
                  <StatusPill status={risk.risk_status} />
                </article>
              ))}
            </div>
          </section>

          <section id="assistant" className="section-block assistant-section">
            <div className="assistant-intro">
              <span className="assistant-mark">
                <Sparkles size={21} />
              </span>
              <div>
                <span className="eyebrow">
                  Governed conversational analytics
                </span>
                <h2>Ask SupplyGraph</h2>
                <p>
                  Every answer resolves to a canonical metric and returns its
                  Snowflake evidence.
                </p>
              </div>
            </div>

            <div className="assistant-layout">
              <form className="question-panel" onSubmit={handleAsk}>
                <label>Perspective</label>
                <ToggleButtonGroup
                  exclusive
                  size="small"
                  value={persona}
                  onChange={(_, value: Persona | null) =>
                    value && setPersona(value)
                  }
                  aria-label="Business perspective"
                  className="persona-toggle"
                >
                  <ToggleButton value="planning">Planning</ToggleButton>
                  <ToggleButton value="procurement">Procurement</ToggleButton>
                  <ToggleButton value="logistics">Logistics</ToggleButton>
                </ToggleButtonGroup>

                <label htmlFor="question">Question</label>
                <TextField
                  id="question"
                  multiline
                  minRows={3}
                  fullWidth
                  value={question}
                  onChange={(event) => setQuestion(event.target.value)}
                  placeholder="Ask about delivery, inventory, fulfillment, quality, or landed cost"
                  className="question-input"
                />
                <div className="prompt-list">
                  {promptSuggestions.map((prompt) => (
                    <button
                      key={prompt}
                      type="button"
                      onClick={() => setQuestion(prompt)}
                    >
                      {prompt}
                    </button>
                  ))}
                </div>
                <Button
                  type="submit"
                  variant="contained"
                  endIcon={
                    chatMutation.isPending ? (
                      <CircularProgress size={15} color="inherit" />
                    ) : (
                      <Send size={16} />
                    )
                  }
                  disabled={
                    chatMutation.isPending || question.trim().length < 3
                  }
                  className="ask-button"
                >
                  Ask governed data
                </Button>
              </form>

              <div className="answer-panel" aria-live="polite">
                {!assistantResult &&
                  !chatMutation.isPending &&
                  !unsupportedMessage && (
                  <div className="answer-empty">
                    <MessageSquareText size={30} strokeWidth={1.5} />
                    <strong>Your answer will appear here</strong>
                    <span>
                      Definition, formula, filters, SQL, and source rows are
                      included.
                    </span>
                  </div>
                )}
                {unsupportedMessage && !chatMutation.isPending && (
                  <Alert severity="info" className="snapshot-alert">
                    {unsupportedMessage}
                  </Alert>
                )}
                {chatMutation.isPending && (
                  <div className="answer-empty">
                    <CircularProgress size={28} />
                    <strong>Resolving governed metric</strong>
                    <span>
                      Checking the metric catalog and approved semantic layer.
                    </span>
                  </div>
                )}
                {assistantResult && !chatMutation.isPending && (
                  <div className="answer-content">
                    <div className="answer-topline">
                      <span className="verified-label">
                        <ShieldCheck size={15} /> Governed answer
                      </span>
                      {assistantResult.interpretation_source === 'cortex' && (
                        <span className="demo-label">Cortex interpreted</span>
                      )}
                      {chatMutation.isError && (
                        <span className="demo-label">Demo snapshot</span>
                      )}
                    </div>
                    <h3>{assistantResult.answer}</h3>
                    <div className="answer-metric">
                      <span>{assistantResult.metrics[0].display_name}</span>
                      <strong>
                        {assistantResult.metrics[0].unit === '%'
                          ? `${assistantResult.metrics[0].value.toFixed(2)}%`
                          : assistantResult.metrics[0].value.toLocaleString(
                              'en-US',
                            )}
                      </strong>
                    </div>
                    <div className="evidence-grid">
                      <div>
                        <span>Canonical metric</span>
                        <strong>
                          {assistantResult.evidence.canonical_metric}
                        </strong>
                      </div>
                      <div>
                        <span>Period</span>
                        <strong>{assistantResult.evidence.period}</strong>
                      </div>
                      <div>
                        <span>Source object</span>
                        <strong>{assistantResult.evidence.source_object}</strong>
                      </div>
                      <div>
                        <span>Semantic view</span>
                        <strong>{assistantResult.evidence.semantic_view}</strong>
                      </div>
                    </div>
                    <div className="definition-block">
                      <span>Definition</span>
                      <p>{assistantResult.evidence.definition}</p>
                      <code>{assistantResult.evidence.formula}</code>
                    </div>
                    <details className="sql-disclosure">
                      <summary>
                        <FileSearch size={16} /> View governed SQL
                      </summary>
                      <pre>{assistantResult.sql}</pre>
                    </details>
                  </div>
                )}
              </div>
            </div>
          </section>

          <footer className="app-footer">
            <span>SupplyGraph AI · CoCo CLI Hackathon 2026</span>
            <span>
              <ShieldCheck size={14} /> Metrics governed in Snowflake
            </span>
          </footer>
        </div>
      </main>
    </div>
  )
}